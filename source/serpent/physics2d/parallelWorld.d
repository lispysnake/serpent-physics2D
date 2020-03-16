/*
 * This file is part of serpent.
 *
 * Copyright © 2019-2020 Lispy Snake, Ltd.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

module serpent.physics2d.parallelWorld;

public import serpent.physics2d.abstractWorld;
public import gfm.math;

import chipmunk;
import serpent.core.view;

/**
 * Multi-threaded World implementation
 */
final class ParallelWorld : AbstractWorld
{

public:

    /**
     * Construct a new ParallelWorld.
     */
    this()
    {
        space = cpHastySpaceNew();
        space.userData = cast(void*) this;
    }

    ~this()
    {
        cpHastySpaceFree(space);
        space = null;
    }

    /**
     * Step through execution of the world
     */
    final override void step(View!ReadWrite view, float frameTime) @trusted
    {
        cpHastySpaceStep(space, cast(cpFloat) frameTime);
        this.processUpdates(view);
    }

    /**
     * Return the number of threads used in the space
     */
    final @property ulong threads() @trusted
    {
        return cpHastySpaceGetThreads(space);
    }

    /**
     * Set the number of threads in the space
     */
    final @property void threads(ulong t) @trusted
    {
        cpHastySpaceSetThreads(space, t);
    }
}