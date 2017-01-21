import classes
import graphics
import sys

def test(filename):
    data = classes.Parser(filename)
    nodes, elements, loads = data.get_all()
    truss = classes.Truss2D(nodes, elements, loads)
    #truss.print_info()
    #print("\n=== SOLUTION")
    sol = classes.Solver(truss)
    sol.solve()
    sol.get_reactions()
    sol.get_forces_stresses()
    # print("\n--- displacements")
    # print(sol.u)
    # print("\n--- reactions")
    # print(sol.R)
    # print("\n--- forces")
    # print(sol.forces)

    print("Generating output ...")
    g = graphics.Graphics(sol, data.filename)
    g.output_forces()
    print("DONE")

    input("\nPress ENTER to exit")

if __name__ == '__main__':

    filename = sys.argv[1]
    test(filename)

    # filename = r"E:\Python_Scripts\moje\DSM3\test models\truss01.tpy"
    # data = classes.Parser(filename)
    # nodes, elements, loads = data.get_all()
    # truss = classes.Truss2D(nodes, elements, loads)
    # truss.print_info()
    # print("\n=== SOLUTION")
    # sol = classes.Solver(truss)
    # sol.solve()
    # sol.get_reactions()
    # sol.get_forces_stresses()
    # print("\n--- displacements")
    # print(sol.u)
    # print("\n--- reactions")
    # print(sol.R)
    # print("\n--- forces")
    # print(sol.forces)
    # #print(truss.dof_dict_node)
    #
    # g = graphics.Graphics(sol, data.filename)
    # g.output_forces()
    #
    # input("\nPress ENTER to exit")

    # print("-----check")
    # for key, value in truss.node_dict.items():
    #     print(key, value.label, value.get_point())
    # for key, value in truss.element_dict.items():
    #     print(key, value.node1.get_point(), value.node2.get_point(), value.node_labels)
